class Notekit < Formula
  desc "A GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  license "GPL-3.0-or-later"
  head "https://github.com/sp1ritCS/notekit.git", branch: "osx"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "sp1ritCS/tap/clatexmath"
  depends_on "fontconfig"
  depends_on "gtkmm3"
  depends_on "gtksourceviewmm3"
  depends_on "hicolor-icon-theme"
  depends_on "jsoncpp"
  depends_on "librsvg"
  depends_on "zlib"

  # required to build notekit with LLVM clang
  patch do
    url "https://raw.githubusercontent.com/sp1ritCS/notekit/osx/Apple/llvm.patch"
    sha256 "f38e93a6df315b6a4ff72198c43f5656ffee2435f5d61f6097ffde5223cdc582"
  end

  def install
    mkdir "_build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    on_macos do
      prefix.install "Apple/NoteKit.app"
      bundle_path = prefix.join("NoteKit.app/Contents/MacOS/")
      bundle_path.write_exec_script "#{bin}/notekit"
      chmod "+x", "#{bundle_path}/notekit"
    end
  end

  test do
    system "#{bin}/notekit", "--help"
    on_macos do
      assert_predicate prefix/"NoteKit.app", :exist?
    end
  end
end
