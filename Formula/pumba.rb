class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.7.tar.gz"
  sha256 "5da828d47d7d46305fc921445ad47d9825a1d54f09b8be8a01ff2095c804fe2d"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1aa7d634a02a62e3c6269e5b0500d53335acb081ce402f685a36b3f3b7d74097" => :big_sur
    sha256 "d53c5e9fdf7dde30cbbc423b2a4a23b82ebddb70a9f7eae754b9fb3195d82f5b" => :catalina
    sha256 "85a95a55e3e126c71d0bb2b0c8e6a104bafff5c8af483b21e2f60c670d56cb46" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
