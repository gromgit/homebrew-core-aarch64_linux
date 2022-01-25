class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ff/4e/36a6e77f8c49b2b993d9ff0245a031065435998df6f018fc1f5de16ef884/fonttools-4.29.0.zip"
  sha256 "f4834250db2c9855c3385459579dbb5cdf74349ab059ea0e619359b65ae72037"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89af4e914597f6c8964ea1bfb9c8538747ac81794b926c85d1d92cb31c94fdbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89af4e914597f6c8964ea1bfb9c8538747ac81794b926c85d1d92cb31c94fdbc"
    sha256 cellar: :any_skip_relocation, monterey:       "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, catalina:       "c29f5b23b4afdbe80f3903490d930a79104adb00cc25739af43f75b1b39a416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5e36f8480a3c4b4acd6a9e1752998f0c8bb6979ae07f574268226f1025333b"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
