class FcitxRemoteForOsx < Formula
  include Language::Python::Shebang

  desc "Handle input method in command-line"
  homepage "https://github.com/xcodebuild/fcitx-remote-for-osx"
  url "https://github.com/xcodebuild/fcitx-remote-for-osx/archive/0.4.0.tar.gz"
  sha256 "453c99a0c2e227c29e2db640c592b657342a9294a3386d1810fd4c9237deeaae"
  license "GPL-3.0-or-later"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # need py3.6+ for f-strings
  depends_on "python@3.10" => :build
  depends_on :macos

  def install
    rewrite_shebang detected_python_shebang, "./build.py"

    system "./build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end
