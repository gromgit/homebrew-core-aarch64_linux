class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://github.com/EasyEngine/easyengine/releases/download/v4.3.0/easyengine.phar"
  sha256 "424cf6a7ebaa96b089f059cfd28563973170002df2c78cb93a893cb1c7732cfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a740d8428e4e0e892c3525441c88f5e3b7eac4427ae0de65c9e8fe8a4b12d203"
    sha256 cellar: :any_skip_relocation, big_sur:       "e20e75b71748d161591793a2dea9ae347e18bebc8ee407b54dc6d7287995845c"
    sha256 cellar: :any_skip_relocation, catalina:      "e20e75b71748d161591793a2dea9ae347e18bebc8ee407b54dc6d7287995845c"
    sha256 cellar: :any_skip_relocation, mojave:        "e20e75b71748d161591793a2dea9ae347e18bebc8ee407b54dc6d7287995845c"
  end

  depends_on "dnsmasq"
  depends_on "php"

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
