class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.60.1.tar.gz"
  sha256 "f2e9b37c5bed391b40da5b1c3c9c555250490f95f76fa8b52ec351992db84c43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2656eda175b87974f41cfe8f7937cbc2bbf3d673116783aeac6ef531591588ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5de0a1c75a9a0878b80aebb5590b402d7941682c237151421484154b25d561d"
    sha256 cellar: :any_skip_relocation, monterey:       "2688af90f25215bed1ba37d3a8569bf25cbfd629063edfbe80b1b711d696ca37"
    sha256 cellar: :any_skip_relocation, big_sur:        "beb19f6b650a0f62ed34179e0a2fa2b35ebffc6b0d0c77340a1be89021a5f2b6"
    sha256 cellar: :any_skip_relocation, catalina:       "19a31b621130a718d779ad6eb0c438b064635662726eeae1f33ae0425bbe7e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9219ee2eecd21e758b2974b4771c6c8c9a661ce50c074fe64096a18c9b1044"
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
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
