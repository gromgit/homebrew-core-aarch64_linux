class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.8.1.tar.gz"
  sha256 "85ae6a9ca5c81f9b30cfbf56130dddad9b57e2fc895a0eccf27a88dd619ae905"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dffb4922afd9eab5e5af01f7d102ad59b8a2c71e3a49ba7176f34166a44ef58d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de67121f2521a76986da9f78c4e90b8c7dddeebff0129e84627e7ef370d63b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e6e5901c5ccddf3191a20d3ed73a15dda5e8b532f8fc8c65a0c83349d49faef"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c4d83bd9f590fc484dc85965e848b0038e55500d613492723375e67fb29f46"
    sha256 cellar: :any_skip_relocation, catalina:       "2ee8724291f6ec8423f1416d5a0be0c57db7826e144152baff0e758ba3b14a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c539f729424f4aedb21f48fefb53003c92d6f034f65ed1e74c7d8180093f4991"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
