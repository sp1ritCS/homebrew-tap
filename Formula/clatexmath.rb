class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "e3199b8b80d58717440a506fc7523d9f01b49bd6"
  version "0.0.4"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/clatexmath-0.0.4"
    rebuild 1
    sha256 x86_64_linux: "2484040620726f77d306772d54467595bb7e45dffff2c5ef96b0dd375edc18c2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "fontconfig"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "tinyxml2"

  patch do
    url "https://gist.githubusercontent.com/sp1ritCS/14c0cc891918d58e1af00622f64ee08a/raw/3d0a71ac5c71ad5c9e547cf5ae44c438fa8de0d9/(clatexmath%2520homebrew)%25200001-fix-wierd-osx-issue-with-cxx17.patch"
    sha256 "57d79685d0ed0e9c8b2630cf0a3e7e66a8b90cdd2232b691dabe3c7aa037b091"
  end

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
