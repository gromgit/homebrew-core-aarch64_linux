class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ba3dd64340176bdd418261ad4c05e9f4cd32531bfcb0b9fcec10c2a7b1bc6eb7"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b7fc7c21b6a54c6f23a052286af3fe2a2c72250015cfe5c8aa43d1ca3010a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36939d2de0b14fc358671faba3b69a800d4665188ee9fefa2faed6a8fe719d62"
    sha256 cellar: :any_skip_relocation, monterey:       "c5870c2e1c7f7c76075006906a8336ab4076c446fc7c7eb3a997a0cb81899ce2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f96e26fd0930d0aa2a7aa3386a8a82e424708ab085036e8fa1d9e73102681b9"
    sha256 cellar: :any_skip_relocation, catalina:       "c816385fb7e6b8e269405e54883f7ed6021818003235d1f29a2eebe02994fcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81107e640397a1a4370002b6db7f0a797241c071b7caf017cacead42109434a"
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
