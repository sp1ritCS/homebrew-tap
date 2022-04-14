class Microtex < Formula
  include Language::Python::Shebang

  desc "Dynamic, cross-platform, and embeddable LaTeX rendering library"
  homepage "https://github.com/NanoMichael/MicroTeX/"
  url "https://github.com/NanoMichael/cLaTeXMath.git",
    revision: "4601dda5985447cc17870a1f3781bc96789ad732"
  version "1.0.0"
  license "MIT"
  head "https://github.com/NanoMichael/MicroTeX.git",
    branch: "openmath"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/microtex-1.0.0"
    sha256 cellar: :any, big_sur:      "5a4bce19ca487d1270c825777ea7e483f5fc8cd77d7bcc658416a39e7ee8321e"
    sha256               x86_64_linux: "aa8367f80480d50c0a1435a3f6b08f4ad96e971db1f93a68e28f597fd45d497b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fontforge"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "pango"
  depends_on "python"
  depends_on "qt@5"

  resource "lm-math" do
    url "https://tug.org/svn/texlive/trunk/Master/texmf-dist/fonts/opentype/public/lm-math/latinmodern-math.otf?revision=36915&view=co", { using: :nounzip }
    sha256 "6075562b771f8b82f0c179e363389684f2dd09de30038269e2628e504bd7be0f"
  end

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    chdir "prebuilt" do
      resource("lm-math").stage { pkgshare.install Dir["*"].first => "latinmodern-math.otf" }
      system "./otf2clm.sh", "--single", pkgshare/"latinmodern-math.otf", "true", pkgshare

      rewrite_shebang detected_python_shebang, "otf2clm.py"
      inreplace "otf2clm.sh", /otf2clm\.py/, libexec/"microtex-otf2clm.py"

      libexec.install "otf2clm.py" => "microtex-otf2clm.py"
      bin.install "otf2clm.sh" => "microtex-otf2clm"
    end
  end

  test do
    assert_predicate pkgshare/"latinmodern-math.clm2", :exist?
    assert_predicate lib/"pkgconfig/microtex.pc", :exist?
    assert_predicate lib/"libmicrotex.dylib", :exist? if OS.mac?
    assert_predicate lib/"libmicrotex.so", :exist? if OS.linux?
  end
end
