class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.32.0.tar.gz"
  sha256 "4ade4da62b13a7bccdd639a77711dd4922801c4ba5a30771406f23f6cb3db666"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "86fb876c245c0d4ce5dbdb5fb449f9089c4cfce455c772198738711b86ba5b9a" => :catalina
    sha256 "287ff527915c06f474b8920aaf6939485cff0c62e3265d487d5740c68bf26cd1" => :mojave
    sha256 "33e9a367c8de7195896ebad2db7fd791d45cd8de105fa6ff1395c5dd3739392f" => :high_sierra
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
