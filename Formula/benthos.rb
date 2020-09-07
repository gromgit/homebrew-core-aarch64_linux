class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.27.0.tar.gz"
  sha256 "20c79538d4c4adf785e0b150d41a879ee41d92423b69e8ce812656f2d0718b83"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f51bf06b64eb57316955fe7f0f57f0ed72e1290fce606079f13f31276f8c8c5c" => :catalina
    sha256 "7deacd34d6284f64e7b70e5a2c661032bfe0ed74afe4f625889f49d7e7ff6903" => :mojave
    sha256 "7838f4132fa854141caca1928942e57a047d3f20b6fbd1c9261cb23064db1fea" => :high_sierra
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
