class NotekitSp1rit < Formula
  commit = "5c9722e56898e3e00c18c7e919b3e6d44866b2c6"

  desc "GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  url "https://github.com/sp1ritCS/notekit.git",
    revision: commit
  version "0.0.1-20220418"
  license "GPL-3.0-or-later"
  head "https://github.com/sp1ritCS/notekit.git",
    branch: "unimath"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/notekit-sp1rit-0.0.1-20220415"
    rebuild 1
    sha256 cellar: :any, big_sur:      "048f904bca0f8bea8e1d17632855a102a56a65edff800d113510c1178ed133a4"
    sha256               x86_64_linux: "a9ca3513cd972a55ea80689632e3b048735b685c58ee99792abf569e570ab975"
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
    system "#{bin}/notekit", "--help" if ENV["DISPLAY"] || ENV["WAYLAND_DISPLAY"]
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
