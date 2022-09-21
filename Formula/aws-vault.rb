class AwsVault < Formula
  desc "Securely store and access AWS credentials in development environments"
  homepage "https://github.com/99designs/aws-vault"
  url "https://github.com/99designs/aws-vault/archive/v6.5.0.tar.gz"
  sha256 "b2127b20a58fd75d92a2af28e77368dd9ab3c576dc73c3d56c3817e496a45515"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aws-vault"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9caf506044d68e892b1eec850311e7a1aea2cad6e0a94bbd7c83495bfb71e792"
  end

  depends_on "go" => :build

  def install
    # Remove this line because we don't have a certificate to code sign with
    inreplace "Makefile",
      "codesign --options runtime --timestamp --sign \"$(CERT_ID)\" $@", ""
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    system "make", "aws-vault-#{os}-#{arch}", "VERSION=#{version}-#{tap.user}"
    system "make", "install", "INSTALL_DIR=#{bin}", "VERSION=#{version}-#{tap.user}"

    zsh_completion.install "contrib/completions/zsh/aws-vault.zsh"
    bash_completion.install "contrib/completions/bash/aws-vault.bash"
  end

  test do
    assert_match("aws-vault: error: required argument 'profile' not provided, try --help",
      shell_output("#{bin}/aws-vault login 2>&1", 1))
  end
end
