class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.8.0.tar.gz"
  sha256 "601fcb8769ceac6aec451048a611360b36fb4fa6013cc8bcba939b8db1633734"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6c6c01bc7934f1b7c2f73420d4e1e51d587247cf94d473039539eb8b7cab8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fcb2c17032c7dfecb577b33552b340bc199d921490a82ae42bff06217dcba5"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6fa4f5d6c096916a47337d105bb62eee37728f00486894dbdc4fad2c3086ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62d0f415e6461e28ea7f284b2eb65f2c355f92f14fcb0585a2de092ab7f2ab8"
    sha256 cellar: :any_skip_relocation, catalina:       "eb90e742a2c86093732747b0664d8265519a52fa53b4b40d622654512e7d48c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4703c82ba48e923b6cfa543e7630e8c5af97bed5572de188516440a9a0cbb351"
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
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
