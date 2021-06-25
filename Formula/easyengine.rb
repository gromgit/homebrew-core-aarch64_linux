class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.1.5/easyengine.phar"
  sha256 "d9abef0aef4f87a54a9c48abcc999c2565a8ba43d109b11d695fb4abd32261a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c108288f17c9db81c9c5151533e7b293cf353819dd4e7003ba879c2256635e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6b1b7868ace7a2e7d66abc81557c6555b30766379f596d2c5e1db17671b75e4"
    sha256 cellar: :any_skip_relocation, catalina:      "e6b1b7868ace7a2e7d66abc81557c6555b30766379f596d2c5e1db17671b75e4"
    sha256 cellar: :any_skip_relocation, mojave:        "e6b1b7868ace7a2e7d66abc81557c6555b30766379f596d2c5e1db17671b75e4"
  end

  depends_on "dnsmasq"
  depends_on "php@7.4"

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    system bin/"ee config set locale hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match "Darwin", output
  end
end
