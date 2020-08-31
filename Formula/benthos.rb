class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.26.0.tar.gz"
  sha256 "bc73537045ff19b0d91918b89fd5f4edd610f55061ad3e01e350c7dc5397f4cc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6591d4d019587f506a0f044a493d7a3758028850c548fc7ff6b8ccf20d16eed" => :catalina
    sha256 "0dd995a5870dabdf35010e9e5a3c17466ade8d0e916477477552985c7231183f" => :mojave
    sha256 "2c63a2e6f0463327e03cbf6b90aba7c112573df73d18b16991ca5cc2598f4d81" => :high_sierra
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
