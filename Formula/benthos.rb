class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.40.0.tar.gz"
  sha256 "21779176a1fd40a6b4599c0421394fc0433220954069d02274fd86eceee05291"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "652da745dfdc9b392aec4e0e13d1f8e8d3f6dd1d0041e9c37c2d606c392b97ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f9e8fde6943f288af8fcfb14abdb7e4d60f4044b8931c0c28dc0fbbe5aec441"
    sha256 cellar: :any_skip_relocation, catalina:      "5dda90cba483ae1d3053b2b6f99aef420fa0f16301e629109f94c0ac112eb9ac"
    sha256 cellar: :any_skip_relocation, mojave:        "c06e553f48215c146b25487fc293519e4300ae3ad1090e05ba40c95478d18daa"
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
