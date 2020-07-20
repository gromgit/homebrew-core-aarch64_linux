class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.22.0.tar.gz"
  sha256 "89c1448ecbc54167155f0c5fc75b14c275983497513b47d67632674e439d9af6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a112a661a553041498662cb5e208d55a201d3316261e0c87b21f15da1a10971" => :catalina
    sha256 "83ea687c151cbbb9ebf9e413fa54b9a01d506a071f1df9b83e198d3beef44947" => :mojave
    sha256 "c6a5ac989e68f4bcf6c2825d3812a56b2b5349d6761b4f242366c2713446abb3" => :high_sierra
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
