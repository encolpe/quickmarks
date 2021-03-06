Bookmark = require '../models/bookmark'

SendError = (res, details, httpCode = 500) ->
    msg = 'Internal server error: ' + details
    res.send error: true, msg: msg, httpCode
    true

module.exports.all = (req, res) ->
    Bookmark.all (err, bookmarks) ->
        if err
            console.error err
            SendError res, 'while retrieving data'
            return
        res.send bookmarks

module.exports.create = (req, res) ->
    Bookmark.create req.body, (err, bookmark) =>
        if err
            console.error err
            SendError res, 'while creating bookmark'
            return
        res.send bookmark

module.exports.destroy = (req, res) ->
    Bookmark.find req.params.id, (err, bookmark) =>
        if err
            SendError res, 'while finding bookmark with id ' + req.params.id
            return

        if not bookmark
            SendError res, 'bookmark not found', 404
            return

        bookmark.destroy (err) ->
            if err
                console.error err
                SendError res, 'while destroying bookmark'
                return

            res.send success: 'Bookmark successfully deleted'
            bookmark = null

module.exports.update = (req, res) ->
    Bookmark.find req.params.id, (err, bookmark) =>
        bookmark.updateAttributes req.body, (err) ->
            if err
                return res.error 500, "Update failed.", err
            else
                res.send bookmark, 201

module.exports.allTags = (req, res) ->
    Bookmark.allTags (err, tags) ->
        if err
            console.error err
            SendError res, 'while retrieving data'
            return
        res.send tags


EXPORT_HEADER = """
<!DOCTYPE NETSCAPE-Bookmark-file-1>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
      <TITLE>Bookmarks</TITLE>
      <H1>Bookmarks Menu</H1>
      <DL><DT><H3>Cozy Bookmark</H3>
        <DL>
"""
EXPORT_FOOTER = """
        </DL>
      </DL>
"""

MakeLink = (name, link, date, tags, description) ->
    date = +date
    ret = "<DT><A HREF='#{link}' ADD_DATE='#{date}' LAST_MODIFIED='#{date}'"
    if tags?
        ret += " TAGS='#{tags}'"
    dd = ""
    if description?
        dd += "<DD>#{description}</DD>"
    ret += ">#{name}</A></DT>" + dd + "\n"
    ret

module.exports.export = (req, res) ->
    Bookmark.all (err, bookmarks) ->
        if err
            console.error err
            SendError res, 'while retrieving data for export'
            return

        exported = EXPORT_HEADER
        for b in bookmarks
            name = b.title
            link = b.url
            creation_date = new Date b.created
            tags = b.tags
            description = b.description
            exported += MakeLink name, link, creation_date, tags, description

        exported += EXPORT_FOOTER
        res.setHeader 'Content-disposition', 'attachment; filename=bookmarks.html'
        res.send exported
