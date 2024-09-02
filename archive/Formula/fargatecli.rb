class Fargatecli < Formula
  desc "CLI for AWS Fargate"
  homepage "https://github.com/awslabs/fargatecli"
  url "https://github.com/awslabs/fargatecli/archive/0.3.2.tar.gz"
  sha256 "f457745c74859c3ab19abc0695530fde97c1932b47458706c835b3ff79c6eba8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fargatecli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c0b9ed29aff74de036ea444a0367f73fbbc518b4ae424e90ad480b4316923ef3"
  end

  deprecate! date: "2022-03-16", because: :unsupported

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fargatecli task list", 1)
    assert_match "Your AWS credentials could not be found", output
  end
end
