class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.30.0.tar.gz"
  sha256 "aeaa904345de2383a783ca988533270a1bd91e7498dc03281cb441a4cc69ee7b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "472ca284b857fb6f01557b23b5a60da83fae76386de0de891d9b4abaa4f22345" => :catalina
    sha256 "863dd64bad1dcfd740fa7e7ceaff390b4aee046e7cebeb5195c4fbff3f606817" => :mojave
    sha256 "8ae246810fccc31d36dd47511819bf9fca8879e40710641862d8a60d321e86bd" => :high_sierra
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
