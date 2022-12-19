class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "3603a3c265a77c3ec64df3631cc9a5c90508ddd5"
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
