class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.44.0.tar.gz"
  sha256 "c7cc44f2361fda9691c2efe74dbea54f577ce49798e4180ba9585173672e6634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4438bcb55065abd98e061bffe4629533f7a8ec0c47436fd14c1fb722670dd42"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4eedb5e89f0ed9ae398f90fc98e559fb23c25cc460274344d73e571647fab43"
    sha256 cellar: :any_skip_relocation, catalina:      "af2b9a35eb7274f97b12c125d11c81a521e7ccdcd2c41fbdbd0c4f03ebcfd645"
    sha256 cellar: :any_skip_relocation, mojave:        "b73043150f8ae385adab04f7c421bfc2fa4492e60cb7cec24e3b7aae7111d86a"
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
