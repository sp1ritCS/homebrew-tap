class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "580809b4c5177fa59a8a645987bbba105361b4a2"
  version "0.0.3"
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
    on_macos do
      assert_predicate lib/"libclatexmath.dylib", :exist?
    end
    on_linux do
      assert_predicate lib/"libclatexmath.so", :exist?
    end
  end
end
