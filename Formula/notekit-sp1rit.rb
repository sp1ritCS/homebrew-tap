class NotekitSp1rit < Formula
  commit = "f7b6e98e2e4a6320793ec21189a10d2bbd003bf5"

  desc "GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  url "https://github.com/sp1ritCS/notekit.git",
    revision: commit
  version "0.0.1-20220415"
  license "GPL-3.0-or-later"
  head "https://github.com/sp1ritCS/notekit.git",
    branch: "unimath"

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
  depends_on "jsoncpp"
  depends_on "librsvg"
  depends_on "sp1ritCS/tap/microtex"
  depends_on "zlib"

  # from https://github.com/blackhole89/notekit/pull/121
  patch :p1, :DATA

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    microtex = Formula["microtex"]
    system "#{microtex.bin}/microtex-otf2clm", "--batch", share/"notekit/data/fonts/", "true", microtex.pkgshare
    Dir[share/"notekit/data/fonts/*.otf"].each do |font|
      microtex.pkgshare.install_symlink font
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
    system "#{bin}/notekit", "--help"
    assert_predicate prefix/"NoteKit.app", :exist? if OS.mac?
  end
end
__END__
diff --git a/mainwindow.cpp b/mainwindow.cpp
index f5aa30d..a8e570c 100644
--- a/mainwindow.cpp
+++ b/mainwindow.cpp
@@ -1,5 +1,6 @@
 #include "mainwindow.h"
 #include "navigation.h"
+#include <clocale>
 #include <iostream>
 #include <fontconfig/fontconfig.h>
 #include <locale.h>
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
