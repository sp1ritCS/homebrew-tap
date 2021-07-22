class Clatexmath < Formula
  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/cLaTeXMath/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "dc32540664276a00805b21a0fb5cd6418bacdb54"
  version "0.0.4"
  license "MIT"
  head "https://github.com/NanoMichael/cLaTeXMath.git"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/clatexmath-0.0.3"
    rebuild 2
    sha256 cellar: :any, catalina:     "b5c840f84755d8f472a639d8966e52204288ba583f253292b3c670f25684c0bd"
    sha256               x86_64_linux: "462c58a43607d545cf5d5f7f913b810b84b0acd297f80e6b3e070f2a95f45fe8"
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
    on_macos do
      assert_predicate lib/"libclatexmath.dylib", :exist?
    end
    on_linux do
      assert_predicate lib/"libclatexmath.so", :exist?
    end
  end
end
