class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/22.06.tar.gz"
  sha256 "baf111cd99755b6ec17a694a3edf6fdf6886ffb606288451e6014de42bff3939"
  license "Apache-2.0"
  head "https://github.com/porjo/youtubeuploader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7607706fdf7aa184bbffae10012705d6c48752550f3dc4d3aa351f367881c71e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf637386f6edf508a3c4b0a63f3ea8beb30f7e7a4fd0523e90253d508459ba8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e73336a16d884c032dcbbf00ba249d6be8a0101f337b1c9d3ac331524439cf3"
    sha256 cellar: :any_skip_relocation, ventura:        "8a16cdb7652e91cbfcc26ff923629134e4a99e1b91697e49769ebd4e899cb323"
    sha256 cellar: :any_skip_relocation, monterey:       "4b3a029b1bf0b3f9a4ed2d71130828286624fb9e2e66bd6e5a9b8963eea71dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5ebc4f26f516589229cc6fc02c39529b3f3e674da4ebdb7591ba85afe816a1"
    sha256 cellar: :any_skip_relocation, catalina:       "9e9b394c72f50c3049269e23aa8534ab5f036c2a10a98f6347f682fc577a5b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8013181d71607e29d777511a64fd3244451414fd2f37c69ec56bfedb4864ce9b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -X main.appVersion=#{version}")
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -version")

    # OAuth
    (testpath/"client_secrets.json").write <<~EOS
      {
        "installed": {
          "client_id": "foo_client_id",
          "client_secret": "foo_client_secret",
          "redirect_uris": [
            "http://localhost:8080/oauth2callback",
            "https://localhost:8080/oauth2callback"
           ],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://accounts.google.com/o/oauth2/token"
        }
      }
    EOS

    (testpath/"request.token").write <<~EOS
      {
        "access_token": "test",
        "token_type": "Bearer",
        "refresh_token": "test",
        "expiry": "2020-01-01T00:00:00.000000+00:00"
      }
    EOS

    output = shell_output("#{bin}/youtubeuploader -filename #{test_fixtures("test.m4a")} 2>&1", 1)
    assert_match "oauth2: cannot fetch token: 401 Unauthorized", output.strip
  end
end
