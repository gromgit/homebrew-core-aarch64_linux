class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.5.4.tar.gz"
  sha256 "1728ee7eb5d87d9838972c1c441a7323315ded01c09d1edc7cf65c0e201a9fc9"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8176dd84e5a90e638a7aab52f37d1236253281405df42115cfe124c1aac6d40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "869643710683a94d43f2f518caff136aaf9dacfa62437cf31726fc5a3ac1b1cc"
    sha256 cellar: :any_skip_relocation, monterey:       "48fb69d0e9562b0fae55caaee935dad1f2f485a6246e8bec2c29d9ebe1c62143"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb7412e7e664da08b36d4a1c7e41ed3fa249b90f7d29cbd2c3726ff6e0db6270"
    sha256 cellar: :any_skip_relocation, catalina:       "fc7bd1bd8fcd5ad783296d7174a23cfc6eff8cdae94a8c62b61b4116c347b894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b877caa6debf8669b86664828d33f50e3a18781e639e0085f80b0eb7199370e6"
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
