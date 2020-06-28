class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.19.0.tar.gz"
  sha256 "593f102d2119c29829603ab736110b385de046179d13bca0fe5c565109b94a66"

  bottle do
    cellar :any_skip_relocation
    sha256 "b003b0dfdd876e4a3dd3dd3aad15dbf339d71f61f90c9849420bd3301a539ede" => :catalina
    sha256 "265d61d3e33d4eb24b80e6e3700183b222768b6deb561884577a9b210d042547" => :mojave
    sha256 "bbd8737d7565570f34bd2b059797228c2245ed94d0f4ac25e08126675d7f9d5b" => :high_sierra
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
