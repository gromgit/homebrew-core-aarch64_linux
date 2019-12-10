class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.1.2.tar.gz"
  sha256 "8d7097b8cf22d8ad384286f3aacf10bbe643a2484b5cf60a494a8233ae78c539"

  bottle do
    cellar :any_skip_relocation
    sha256 "03890cad65a0b2224314635e58b372178995390d4a7c97b913d59002bd293b21" => :catalina
    sha256 "98aef91d7bb435f715c126fbcd0d15dec7e319e986ee756f0a7a1623d3a1b374" => :mojave
    sha256 "1d718db93a057382ad804db628773a5b51f20f47d1274b61b99c50c9e184fb97" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s

    system "make", "darwin"
    bin.install "build/darwin/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
