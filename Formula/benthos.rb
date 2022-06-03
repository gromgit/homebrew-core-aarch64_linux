class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.2.0.tar.gz"
  sha256 "5df106650ed8ca64435c11717814dc6ec6fbca3a75e0d809197fa617da90dcf5"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a94a9e6a514d4f0659557d02428552cb7ccd298d9718323fad1580caec3e014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7675e080359be5b03f763f7baef43a8a5979900553d03e39cc35a0b1eadc0907"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2c021e7f1cf0f44940772a659e0a179ecceb84b4940d02cdf5092ed56723bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d7752bf380432a9e93df5f6709623a43dcfca9d955540808bbdec74e7f4899"
    sha256 cellar: :any_skip_relocation, catalina:       "fa56a5c76542e1c932c993f65f6fbf4493a31e35eb6935a7af54650091566594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d7a90512ab612d8ca2a76a8ebcb7b662459ae035b7a811407b80dab03991be"
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
