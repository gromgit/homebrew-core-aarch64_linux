class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.36.0.tar.gz"
  sha256 "3b8b3608d97a9e8e58bedf3a91f31c6141d490ebbac445358cf27d1118d27d97"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "43e0648458bcaf9aab9f00c6954ea4e6375335b7eb48eceb9a07d3cd3c41cb59" => :big_sur
    sha256 "4ad14368a431eb437b655e9fb913b3431db9866363f8c648334a7d5e9dc93640" => :catalina
    sha256 "14cf3ad6c2a7698ccdef0512d76958120ac8cd8122b80c39ed9d9a5eb550cbbd" => :mojave
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
