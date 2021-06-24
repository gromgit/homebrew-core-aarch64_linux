class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.0.1",
      revision: "c1edb47838c7a0862e0bea80622f98798f34fd4e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "191d0e22a3a4bbdd8400413c2adcce6dfbf088706b40f804cca2738580eb8c7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8e1a75b4ba9a6353055866fae3cc0e17898f49b185d1b8094c6dfb4a90a9080"
    sha256 cellar: :any_skip_relocation, catalina:      "25fd3bfb505971967d2f807b4e54c81319397781f48563ffa119db3c83a0f8a8"
    sha256 cellar: :any_skip_relocation, mojave:        "d0659d95203d06f63f578b5ba6101628d2fe208890cb5123f817fc55f0ce048a"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = [
      "-X #{proj}/common.NAME=gitlab-runner",
      "-X #{proj}/common.VERSION=#{version}",
      "-X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}",
      "-X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable",
      "-X #{proj}/common.BUILT=#{Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")}",
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  plist_options manual: "gitlab-runner start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>SessionCreate</key><false/>
          <key>KeepAlive</key><true/>
          <key>RunAtLoad</key><true/>
          <key>Disabled</key><false/>
          <key>LegacyTimers</key><true/>
          <key>ProcessType</key>
          <string>Interactive</string>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/gitlab-runner</string>
            <string>run</string>
            <string>--working-directory</string>
            <string>#{ENV["HOME"]}</string>
            <string>--config</string>
            <string>#{ENV["HOME"]}/.gitlab-runner/config.toml</string>
            <string>--service</string>
            <string>gitlab-runner</string>
            <string>--syslog</string>
          </array>
          <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
