class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.52.1.tar.gz"
  sha256 "09ec57d7b812972c15728b07c496b15db6fad4b7ac510b31fbb2cb2010874b75"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e7972ecbf01cbd968d39db16546afb93935cca75fb913fc2bf12b1707cc5b8c" => :catalina
    sha256 "328b00b22013fa1818bd3c11f4eac843a31d6892a7471030293b5027d3f05cd6" => :mojave
    sha256 "fd48cf2f9b72b1cd8b61643ebce1cd9e9063822965f5335f2444e2c254e99db8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    mkdir_p buildpath/"src/github.com/rclone/"
    ln_s buildpath, buildpath/"src/github.com/rclone/rclone"
    system "go", "build", "-o", bin/"rclone"
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
