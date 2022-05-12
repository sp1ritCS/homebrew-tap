class NotekitSp1rit < Formula
  commit = "4b6a945772c1f3611149c86157b38ff97d350203"

  desc "GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  url "https://github.com/sp1ritCS/notekit.git", { branch: "unimath", revision: commit }
  version "0.0.1-20220423"
  license "GPL-3.0-or-later"
  head "https://github.com/sp1ritCS/notekit.git",
    branch: "unimath"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/notekit-sp1rit-0.0.1-20220423"
    sha256 cellar: :any, big_sur:      "69d7c61ecdfd846db9ad06394f260508ea5f7d88f05b5a4da7b1cad3a1260dcf"
    sha256               x86_64_linux: "d28ed2be6c6af78e544a04596a6650d5d2881c55fdc7bbe012f87def45a79b21"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "hicolor-icon-theme"
  depends_on "librsvg"
  depends_on "sp1ritCS/tap/microtex"
  depends_on "zlib"

  conflicts_with "notekit", because: "this is a fork of notekit that installs the same files"

  patch :p1, :DATA

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    microtex_pkgshare = share/"microtex"
    system "#{Formula["microtex"].bin}/microtex-otf2clm", "--batch",
      share/"notekit/data/fonts/", "true", microtex_pkgshare
    Dir[share/"notekit/data/fonts/*.otf"].each do |font|
      microtex_pkgshare.install_symlink font
    end

    if OS.mac?
      prefix.install "Apple/NoteKit.app"
      bundle_path = prefix.join("NoteKit.app/Contents/MacOS/")
      bundle_path.write_exec_script "#{bin}/notekit"
      chmod "+x", "#{bundle_path}/notekit"
    end
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/notekit", "--help" if OS.mac? || ENV["DISPLAY"] || ENV["WAYLAND_DISPLAY"]
    assert_predicate prefix/"NoteKit.app", :exist? if OS.mac?
  end
end
__END__
diff --git a/meson.build b/meson.build
index c419e83..be17a17 100644
--- a/meson.build
+++ b/meson.build
@@ -58,5 +58,3 @@ executable('notekit',
        dependencies: deps,
        install : true
 )
-
-meson.add_install_script('build-aux/postinstall.py')
