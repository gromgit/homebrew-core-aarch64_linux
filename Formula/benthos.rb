class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.7.0.tar.gz"
  sha256 "187a919589de8911a6370121eebce5400c89996b600ed1e843c6f18ffc009d56"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b8c79b16f26f704ed0f8154f37329d4baf974009f50122ce2a4f52a0ebc4cd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cbfd3f1b89349261e0d6d7a1983ec4d6f6002a66fed1b9ab1dfa7403d6c80f9"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef478a445158cec320bd4401d166fff7a3487698c375fd5e7598d9c23bb9e45"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e61cbcd817b556545ba697542abd36ee2c2a618d36e00f76650e93fda0064f"
    sha256 cellar: :any_skip_relocation, catalina:       "4575621db43aa5a92158500e0e024e433ebe8f25cb66856ad8463c6e2cd2be28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9795f554f3d5a6f4bd793359e566d352935691abfa24fce9ba689fe36dce3f61"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
