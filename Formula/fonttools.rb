class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/a4/c9/1ce7e091543c090ef7cd6f3e6662815cafaf76071c96a00b380566759f06/fonttools-4.34.2.zip"
  sha256 "3fb3bef8e743dad8fe96e12a47a9ce9bd367ac0a24c089256615518c88309dbd"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb1de4a7358fb523895bfc993fb78192c0606c9b38a68edcd250e3fb63bc8323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb1de4a7358fb523895bfc993fb78192c0606c9b38a68edcd250e3fb63bc8323"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, catalina:       "b3c0659189afe67f7146b7e3634d40baac5ca2fb363886e5966f8931e66624b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a81bf45de9bee4f008b0467bcd992222862c6bb2dd0d94561488814a89a5237"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
