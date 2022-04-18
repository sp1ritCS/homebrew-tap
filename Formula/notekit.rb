class Notekit < Formula
  commit = "9ca343033c208f942152cde1c4f6747f7cdd2850"

  desc "GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  url "https://github.com/blackhole89/notekit.git",
    revision: commit
  version "0.0.1-20220418"
  license "GPL-3.0-or-later"
  head "https://github.com/blackhole89/notekit.git"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "hicolor-icon-theme"
  depends_on "jsoncpp"
  depends_on "librsvg"
  depends_on "sp1ritCS/tap/clatexmath"
  depends_on "zlib"

  conflicts_with "notekit-sp1rit", because: "notekit-sp1rit is a fork of notekit that shares the name of the binary"

  patch do
    url "https://github.com/blackhole89/notekit.git", revision: commit
    apply %w[
      Apple/llvm.patch
    ]
  end

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    if OS.mac?
      prefix.install "Apple/NoteKit.app"
      bundle_path = prefix.join("NoteKit.app/Contents/MacOS/")
      bundle_path.write_exec_script "#{bin}/notekit"
      chmod "+x", "#{bundle_path}/notekit"
    end
  end

  test do
    if OS.mac?
      system "#{bin}/notekit", "--help"
      assert_predicate prefix/"NoteKit.app", :exist?
    end
  end
end
