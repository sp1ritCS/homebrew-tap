class Clatexmath < Formula
  desc "A dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    assert_predicate pkgshare/".clatexmath-res_root", :exist?
    assert_predicate lib/"pkgconfig/clatexmath.pc", :exist?
    assert_predicate lib/"libclatexmath.dylib", :exist?
  end
end
