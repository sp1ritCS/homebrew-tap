class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "52329bbd9d3c21cb92277b7282292e3eeb4c88f5"
  version "0.0.3"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/clatexmath-0.0.3"
    rebuild 1
    sha256 cellar: :any,                 catalina:     "e0ed18c244217338534d5698ac48bac2cd24c80692816020c37e59399608bcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ce79789dcb883cc7a384d45dfef2597a3fb015c1603b0d7f411bf8f69fd4554"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "tinyxml2"
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
