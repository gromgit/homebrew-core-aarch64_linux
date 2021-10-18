class SeleniumServerStandalone < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.0.0/selenium-server-4.0.0.jar"
  sha256 "0e381d119e59c511c62cfd350e79e4150df5e29ff6164dde03631e60072261a5"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b65fc10655486a4b59a0a1f5e850b1920a360463dbd5228a859f803a0e96eea"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b65fc10655486a4b59a0a1f5e850b1920a360463dbd5228a859f803a0e96eea"
    sha256 cellar: :any_skip_relocation, catalina:      "4b65fc10655486a4b59a0a1f5e850b1920a360463dbd5228a859f803a0e96eea"
    sha256 cellar: :any_skip_relocation, mojave:        "4b65fc10655486a4b59a0a1f5e850b1920a360463dbd5228a859f803a0e96eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fef5d9217b4be71f5856639e23b5e8dbb8ac4b36fbe883c6f53fbcd2332e872"
  end

  depends_on "geckodriver" => :test
  depends_on "openjdk"

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server standalone --port #{port}" }
    sleep 6
    output = shell_output("curl --silent localhost:#{port}/status")
    output = JSON.parse(output)

    assert_equal true, output["value"]["ready"]
    assert_match version.to_s, output["value"]["nodes"].first["version"]
  end
end
