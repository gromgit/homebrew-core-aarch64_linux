class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "32db12a89a2162868e2a4191e2c86911fccae715971846f135ac41ec0cd420a3"

  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e8b91a3c8688a2fe313160c4d9c892f6b92e37753bf1e0a0607c2f1e64af24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eebc9979f79e2c8f6eec6067b60896ec1ff76bb83a488f252688420d9650c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e8b91a3c8688a2fe313160c4d9c892f6b92e37753bf1e0a0607c2f1e64af24"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eebc9979f79e2c8f6eec6067b60896ec1ff76bb83a488f252688420d9650c7a"
    sha256 cellar: :any_skip_relocation, catalina:       "3eebc9979f79e2c8f6eec6067b60896ec1ff76bb83a488f252688420d9650c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995d0850aee450f3f7cd208c6d048aacb264ef7f28fafd19d90a6f48a91f346a"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    # workaround from homebrew-core/Formula/pianobar.rb
    on_linux do
      # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    require "pty"
    PTY.spawn bin/"imap-backup setup" do |r, w, pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "exit without saving changes\n"
      assert_match(/Choose an action:/, r.read)
    ensure
      Process.kill("TERM", pid)
    end
  end
end
