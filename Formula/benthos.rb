class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.36.0.tar.gz"
  sha256 "3b8b3608d97a9e8e58bedf3a91f31c6141d490ebbac445358cf27d1118d27d97"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7238475b0cbd437a8278815b2d4b1ad8b2a13fc3156d93250350ce096318d96a" => :big_sur
    sha256 "326ed71dd2ec13b9401663a005b39cdd7a0f13e71ae1357ff32b076b1b0b3ae6" => :catalina
    sha256 "99e2bd99befab6cc1714dd91b6491c552cdf4df6f53341f72f475c3ac7992411" => :mojave
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
