class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.55.0.tar.gz"
  sha256 "038ff6a9dfaa5b70e36abd968f9c420cb0ba167c39e71c11a54890335901e1e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5b70dce62ebe196696c7fd27fec273ae304738154d2f318cbef489e0c80dbec8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a76a021457baeb70ed1dc3c2459f5c8af6f1b37f6f46946b9bad49c60ec9fe07"
    sha256 cellar: :any_skip_relocation, catalina:      "265f82a621dc6702ff8f2ef251197a57382aebb1aeb21fa0817a11c16d7831f4"
    sha256 cellar: :any_skip_relocation, mojave:        "ad342362287bbc0c5bdd1979c425e5f28aa1133560fb252f034a26afcf35aeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f3bff43e2cf74ce05e48b697d1631ea9076a95f7525292626f34fcd1f4ca4b"
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
