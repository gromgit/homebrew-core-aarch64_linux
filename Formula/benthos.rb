class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.8.0.tar.gz"
  sha256 "601fcb8769ceac6aec451048a611360b36fb4fa6013cc8bcba939b8db1633734"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19002b54cb4476afeebdcfe00b24b56f0de4b8a8bc357d758b285cd275a27b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921d1a03a358f994ef9af2b461733b321522bde147b6ef3ac79a86d18a188c67"
    sha256 cellar: :any_skip_relocation, monterey:       "6b8a7d42f30d16df30d886c58569b9f9e9ae384de2ad002bcd3b86f6dfb25f01"
    sha256 cellar: :any_skip_relocation, big_sur:        "0358fff138fc8a1b721c3dcd9337ca4f19eb8abf1a2440ee38731206c5d10fdd"
    sha256 cellar: :any_skip_relocation, catalina:       "b72ca0674ea78e093520dd0f39006e1638504c8fc35a294873b1ea9dedc8c110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc64bb2318ae160c3493b3ddeae8254d0f656033b727227c098e74dcb40d9ae6"
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
