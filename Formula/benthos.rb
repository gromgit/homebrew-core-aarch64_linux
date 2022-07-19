class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.4.1.tar.gz"
  sha256 "c91950426883884ec2564196a9fac1bd617c990915a745787796c2c3bd936d3f"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2cfcfffd3b4b20c0563227b1818c611634052989c5b231e21a21aeb1209ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "056d343b85ea4af9673ce3da93ae945b9705c5c2160a5562e49a991267792786"
    sha256 cellar: :any_skip_relocation, monterey:       "f3b1383b0fb850f4e79575c94fe1bbdf9150b58ec5feba7a176a727242b3c836"
    sha256 cellar: :any_skip_relocation, big_sur:        "e968da6f0c8ea3a79a9a669df6a6d27706be7563a6e46b4dc1acb56d6e03f478"
    sha256 cellar: :any_skip_relocation, catalina:       "31edf29a25e4fc75e4929aab0335a6ec353c8c4bfc9d9f0aba9594763da5c8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e408fbc43e846a2e806708b7250e60edc81177d1a21253a09041e7e9fb42b895"
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
