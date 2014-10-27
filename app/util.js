
var gitparse = function(githubRepoUrl) {
  // regex for "git://github.com/(user)/(repo).git ...", "git@github.com:(user)/(repo).git ...", or "https://github.com/(user)/(repo).git"
  var match = githubRepoUrl.match(/.*\/*github.com[:/]([^/]+)\/([a-z0-9-_.]+).git/i);
  return { 'user': match !== null ? match[1] : 'unknown', 'repo': match !== null ? match[2] : 'unknown' };
};

module.exports = gitparse;