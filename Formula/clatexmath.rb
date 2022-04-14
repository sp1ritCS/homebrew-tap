class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "dc32540664276a00805b21a0fb5cd6418bacdb54"
  version "0.0.4"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/clatexmath-0.0.4"
    sha256 cellar: :any, catalina:     "d45e7742ba5f00d14b91be3f4b57c3a6767e56f792e8826bab081c4444668905"
    sha256               x86_64_linux: "9cf4d4efb3ee33dc597eced1a0477483ea4adbc709ba4f7f83f810a8fd273f77"
  end

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

