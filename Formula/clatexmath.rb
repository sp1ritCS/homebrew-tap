class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "dc32540664276a00805b21a0fb5cd6418bacdb54"
  version "0.0.4"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "tinyxml2"

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
    assert_predicate lib/"libclatexmath.dylib", :exist? if OS.mac?
    assert_predicate lib/"libclatexmath.so", :exist? if OS.linux?
  end
end
