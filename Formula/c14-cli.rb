class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/scaleway/c14-cli"
  url "https://github.com/scaleway/c14-cli/archive/v0.5.0.tar.gz"
  sha256 "b93960ee3ba516a91df9f81cf9b258858f8b5da6238d44a339966a5636643cb2"
  head "https://github.com/scaleway/c14-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "16fc8110913a233923aa9a5e5fae8e28a300e1639a2bc8862785c34d61623229" => :catalina
    sha256 "9547e5c45d10d48de2ff95aabef2cb6d446fbd6f3b706df90d72adf2a363d96b" => :mojave
    sha256 "43107ba495420cf65ab7b3a4f04c1a62de77594ed318e06aba3101213191e694" => :high_sierra
    sha256 "6129daf1900d717da72f13909af71af2bf0d29325f798c02bcf4a68b1bd8edb3" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"c14",
           "-ldflags", "-X github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew",
           "./cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
