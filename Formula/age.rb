class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://filippo.io/age"
  url "https://github.com/FiloSottile/age/archive/v1.0.0.tar.gz"
  sha256 "8d27684f62f9dc74014035e31619e2e07f8b56257b1075560456cbf05ddbcfce"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/age"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d1e19be4a5946568c82ed69577dc8c2e0b0c1ebc495d11b7a0f3be5a4a2e8542"
  end

  depends_on "go" => :build

  def install
    bin.mkpath
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-o", bin, "filippo.io/age/cmd/..."
    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test")
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
