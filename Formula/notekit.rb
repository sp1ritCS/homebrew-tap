class Notekit < Formula
  commit = "845a7cb3f508a4e8d3b69b196536e9be9b5a98e8"

  desc "GTK3 hierarchical markdown notetaking application with tablet support"
  homepage "https://github.com/blackhole89/notekit/"
  url "https://github.com/blackhole89/notekit.git",
    revision: commit
  version "0.0.1-20210513"
  license "GPL-3.0-or-later"
  head "https://github.com/blackhole89/notekit.git"

  bottle do
    root_url "https://github.com/sp1ritCS/homebrew-tap/releases/download/notekit-0.0.1-20210513"
    sha256 cellar: :any, catalina:     "3c09b0f41e444dc192791070bec91efd6c46ba82898f273014d44a8f58ac9849"
    sha256               x86_64_linux: "c43f48ee5d787f9c98fc905e44a5ed29c2166ca92bf64fa9c079378e03606802"
  end

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

    on_macos do
      prefix.install "Apple/NoteKit.app"
      bundle_path = prefix.join("NoteKit.app/Contents/MacOS/")
      bundle_path.write_exec_script "#{bin}/notekit"
      chmod "+x", "#{bundle_path}/notekit"
    end
  end

  test do
    on_macos do
      system "#{bin}/notekit", "--help"
      assert_predicate prefix/"NoteKit.app", :exist?
    end
  end
end
