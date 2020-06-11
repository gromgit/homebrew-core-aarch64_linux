class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.17.0.tar.gz"
  sha256 "401d2fd4c1795f67c813d3f6ce3d77c5f264047f4eb6c52b861e817ebeeaaac2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b01d4117e4133e0d0a3f3a491d6d27775b0d459d041c03ca32be9e8ea401a2fd" => :catalina
    sha256 "7da85e02185751e006b4bb6ee6e5f6771519ea98e98c33893e1d8690737255a7" => :mojave
    sha256 "5ac803ca081885e5a3d920a2e95ac0607081141250d8ccded589602c3ca7823c" => :high_sierra
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
