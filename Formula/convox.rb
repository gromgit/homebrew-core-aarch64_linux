class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.23.tar.gz"
  sha256 "3833abb13ae7e7e6bff224f5721e598907032e8b5c66c8f208a56f26d14c41eb"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "61eb6e9b693faae340ac537275310c0901e2c98f489ffa7f3e177a5a686751e2" => :catalina
    sha256 "7d413941fb786f9990ef2408f86f2ef294647284a6ee30901bbd5b81c918b14d" => :mojave
    sha256 "1d57c03c80b2a635ff6d1e95a51a55f0fb6c0e5410f6468299f28430610fc85d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
            "-o", bin/"convox", "-v", "./cmd/convox"
    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
