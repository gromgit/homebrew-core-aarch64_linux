class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20221010.tar.gz"
  sha256 "987b2ddac349e5ac2b91b40b06f7686dcf316c37bfe82c566fdc7503f0b4d97d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a5174d875e8d580275dab0e869d326be4db15c3dc3ea3e6ac55378267741d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee982490ddd05b9cad8aae2d2152342b50459402fc348c76e20dfc32f556f835"
    sha256 cellar: :any_skip_relocation, monterey:       "88944b9e0620ca134dbcff68d262024b34ef6c26d4c79b4ceb9098c86c3610ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd4525865739fd62d6d9bb3ae19c9a455bb12636cd1dbf0716660369bd4a237"
    sha256 cellar: :any_skip_relocation, catalina:       "3afa95e3386434d472b13b7ec33466f789006fa1ea0088872cdefd2b25271f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "378d428dad55eaca5496098754d76eb31ab44dd29b0f0952567a7b0a0be4124e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    # We expect something like "brook://server?password=hello&server=1.2.3.4%3A56789&username="
    uri = URI(output)
    assert_equal "brook", uri.scheme
    assert_equal "server", uri.host

    query = URI.decode_www_form(uri.query).to_h
    assert_equal "1.2.3.4:56789", query["server"]
    assert_equal "hello", query["password"]
    assert_equal "", query["username"]
  end
end
