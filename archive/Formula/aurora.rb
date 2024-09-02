class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aurora"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "77447a345086014be6b01fa2912bd0fd300933e0f8ffde5ce9c7c06325a7b2be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"aurora"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
